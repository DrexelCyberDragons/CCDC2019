import os

def get_os():
    if os.path.exists('/etc/debian_version'):
        return "debian"
    if os.path.exists('/etc/redhat-release'):
        return "rhel"
    if os.path.exists('/etc/SuSE-release'):
        return "sles"
    os_file = None
    if os.path.exists('/etc/os-release'):
        os_file = "/etc/os-release"
    elif os.path.exists('/usr/lib/os-release'):
        os_file = '/usr/lib/os-release'
    if os_file:
        with open('/etc/os-release') as operating_system:
            for line in operating_system:
                if "ID_LIKE" in line:
                    if "debian" in line:
                        return "debian"
                    if "rhel" in line:
                        return "rhel"
                    if "sles" in line:
                        return "sles"
                if "ID" in line:
                    if "rhel" in line:
                        return "rhel"
                    if "debian" in line:
                        return "debian"
                    if "sles" in line:
                        return "sles"
    raise NotImplemented("Unable to determine OS")

if __name__ == "__main__":
    print get_os()
