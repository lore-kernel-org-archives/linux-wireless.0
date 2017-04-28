Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.kerio.com ([195.39.55.12]:56287 "EHLO mail.kerio.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162814AbdD1JEr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 05:04:47 -0400
Received: from localhost ([127.0.0.1])
        by mail.kerio.cz with ESMTPA
        for linux-wireless@vger.kernel.org;
        Fri, 28 Apr 2017 11:04:43 +0200
From: Roman Jokl <rjokl@kerio.com>
Subject: qca988x firmware crash
To: linux-wireless@vger.kernel.org
Message-ID: <9ac0f833-8835-e2e8-2ebc-9b60f04b44d3@kerio.com> (sfid-20170428_110542_407617_351C6C8F)
Date: Fri, 28 Apr 2017 11:04:42 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080509090201060403080002"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080509090201060403080002
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello,

I have issue with qca988x firmware. It crash every couple of hours. I hav=
e tested dozen of versions, e.g:

-rw-r--r--  1 root root   245088 Jan  2 12:21 firmware-5.bin_10.2.4.70-2
-rw-r--r--  1 root root   248188 Apr 19 06:30 firmware-5.bin_10.2.4.70.54=

-rw-r--r--  1 root root   248232 Dec  7 17:16 firmware-5.bin_10.2.4.70.59=
-2
-rw-r--r--  1 root root   249384 Apr 20 07:01 firmware-5.bin_10.2.4.70.63=
-2

Below is dmesg output. I'm not sure where to report or what data to inclu=
de. Can anyone help me?

Regards,
Roman Jokl


[27/Apr/2017 21:58:11] {syslog} kernel: [20328.303907] ath10k_pci 0000:04=
:00.0: firmware crashed! (uuid 074b9050-dc32-43e5-90b5-6f8439c039f7)
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.303923] ath10k_pci 0000:04=
:00.0: qca988x hw2.0 (0x4100016c, 0x043202ff) fw 10.2.4.70-2 api 5 htt 2.=
1 wmi 5 cal otp max_sta 128
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.303927] ath10k_pci 0000:04=
:00.0: debug 1 debugfs 1 tracing 0 dfs 0 testmode 0
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.315964] ath10k_pci 0000:04=
:00.0: failed to read diag value at 0xdfb00804: -16
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.315969] ath10k_pci 0000:04=
:00.0: failed to get memcpy hi address for firmware address 4: -16
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.315972] ath10k_pci 0000:04=
:00.0: failed to read firmware dump area: -16
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.376485] ieee80211 phy0: Ha=
rdware restart was requested
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.495780] ath10k_pci 0000:04=
:00.0: failed to read diag value at 0xdfb00800: -16
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.495788] ath10k_pci 0000:04=
:00.0: failed to poke copy engine: -16
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.560816] ath10k_pci 0000:04=
:00.0: failed to read diag value at 0xdfb00800: -16
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.560822] ath10k_pci 0000:04=
:00.0: failed to poke copy engine: -16
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.625859] ath10k_pci 0000:04=
:00.0: failed to read diag value at 0xdfb00800: -16
[27/Apr/2017 21:58:11] {syslog} kernel: [20328.625865] ath10k_pci 0000:04=
:00.0: failed to poke copy engine: -16
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672542] ath10k_pci 0000:04=
:00.0: failed to read device register, device is gone
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672550] ath10k_pci 0000:04=
:00.0: failed to wait for target after cold reset: -5
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672554] ath10k_pci 0000:04=
:00.0: firmware crashed during chip reset
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672560] ath10k_pci 0000:04=
:00.0: firmware crashed! (uuid 13d14a67-0459-4a84-a22a-d0981caf8ce9)
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672566] ath10k_pci 0000:04=
:00.0: qca988x hw2.0 (0x4100016c, 0x043202ff) fw 10.2.4.70-2 api 5 htt 2.=
1 wmi 5 cal otp max_sta 128
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672569] ath10k_pci 0000:04=
:00.0: debug 1 debugfs 1 tracing 0 dfs 0 testmode 0
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672577] ath10k_pci 0000:04=
:00.0: failed to read firmware dump area: -5
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672584] ath10k_pci 0000:04=
:00.0: failed to reset chip: -5
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672587] ath10k_pci 0000:04=
:00.0: Could not init hif: -5
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672590] ------------[ cut =
here ]------------
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672611] WARNING: CPU: 2 PI=
D: 38 at /build/backports-4.2.6-1-yRWgcw/backports-4.2.6-1-1/net/mac80211=
/util.c:1800 ieee80211_reconfig+0x63a/0x17a0 [mac80211]()
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672614] Hardware became un=
available during restart.
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672615] Modules linked in:=
 authenc xfrm6_mode_tunnel xfrm4_mode_tunnel cbc hmac xfrm4_tunnel tunnel=
4 ipcomp xfrm_ipcomp esp4 ah4 af_key nfnetlink_queue nfnetlink_log nfnetl=
ink bluetooth 6lowpan_iphc ctr ccm pppoe pppox bridge stp llc xfrm_user x=
frm_algo acpi_pad sbs sbshc battery thermal video fan ac acpi_ipmi ipmi_m=
sghandler loop ppp_generic slhc kvnet(O) kipf(O) vfat fat arc4 ath10k_pci=
(O) ath10k_core(O) ath(O) mac80211(O) evdev igb psmouse cfg80211(O) coret=
emp serio_raw i2c_algo_bit pcspkr i2c_core compat(O) dca=20
rfkill ptp pps_core button ext4 crc16 mbcache jbd2 sg sd_mod crc_t10dif c=
rct10dif_common ahci ehci_pci libahci ehci_hcd libata usbcore scsi_mod us=
b_common processor thermal_sys
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672674] CPU: 2 PID: 38 Com=
m: kworker/2:1 Tainted: G           O  3.16.0-k4-kerio-amd64 #1 Debian 3.=
16.7-ckt20-1+deb8u3~kerio4
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672677] Hardware name: To =
be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M., BIOS 5=
=2E6.5 09/02/2015
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672686] Workqueue: events =
ieee80211_restart_work [mac80211]
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672688]  0000000000000009 =
ffffffff81507119 ffff88007ac43d50 ffffffff810677d7
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672692]  ffff880177ca8ea0 =
ffff88007ac43da0 00000000fffffffb ffff88017fd16300
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672696]  0000000000000000 =
ffffffff8106783c ffffffffa03d8628 ffffffff00000018
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672700] Call Trace:
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672707]  [<ffffffff8150711=
9>] ? dump_stack+0x41/0x51
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672713]  [<ffffffff810677d=
7>] ? warn_slowpath_common+0x77/0x90
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672717]  [<ffffffff8106783=
c>] ? warn_slowpath_fmt+0x4c/0x50
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672729]  [<ffffffffa03a2d2=
a>] ? ieee80211_reconfig+0x63a/0x17a0 [mac80211]
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672734]  [<ffffffff81073c3=
9>] ? try_to_del_timer_sync+0x49/0x60
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672738]  [<ffffffff8150ba9=
e>] ? mutex_lock+0xe/0x2a
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672747]  [<ffffffffa03701c=
c>] ? ieee80211_restart_work+0x6c/0xa0 [mac80211]
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672751]  [<ffffffff8108174=
2>] ? process_one_work+0x172/0x420
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672755]  [<ffffffff81081dd=
3>] ? worker_thread+0x113/0x4f0
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672759]  [<ffffffff8150966=
1>] ? __schedule+0x2b1/0x700
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672763]  [<ffffffff81081cc=
0>] ? rescuer_thread+0x2d0/0x2d0
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672767]  [<ffffffff8108803=
d>] ? kthread+0xbd/0xe0
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672771]  [<ffffffff81087f8=
0>] ? kthread_create_on_node+0x180/0x180
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672774]  [<ffffffff8150d25=
8>] ? ret_from_fork+0x58/0x90
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672778]  [<ffffffff81087f8=
0>] ? kthread_create_on_node+0x180/0x180
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672781] ---[ end trace 6b8=
b0e933a93c4f3 ]---
[27/Apr/2017 21:58:14] {syslog} kernel: [20331.672980] ------------[ cut =
here ]------------


--------------ms080509090201060403080002
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: Elektronicky podpis S/MIME

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFrzCC
BaswggUUoAMCAQICAxAEqTANBgkqhkiG9w0BAQUFADCBuzELMAkGA1UEBhMCQ1oxFzAVBgNV
BAgTDkN6ZWNoIFJlcHVibGljMQ8wDQYDVQQHEwZQaWxzZW4xGzAZBgNVBAoTEktlcmlvIFRl
Y2hub2xvZ2llczEeMBwGA1UECxMVQ2VydGlmaWNhdGUgQXV0aG9yaXR5MSAwHgYDVQQDExdL
ZXJpbyBUZWNobm9sb2dpZXMgSW5jLjEjMCEGCSqGSIb3DQEJARYUaG9zdG1hc3RlckBrZXJp
by5jb20wHhcNMTIxMDE2MTYwNDUzWhcNMTcxMDE2MTYwNDUzWjCBvjELMAkGA1UEBhMCQ1ox
FzAVBgNVBAgTDkN6ZWNoIFJlcHVibGljMQswCQYDVQQHEwJDWjEbMBkGA1UEChMSS2VyaW8g
VGVjaG5vbG9naWVzMSkwJwYDVQQKEyBjMjFmOTY5YjVmMDNkMzNkNDNlMDRmOGYxMzZlNzY4
MjEMMAoGA1UECxMDS1dGMRMwEQYDVQQDEwpSb21hbiBKb2tsMR4wHAYJKoZIhvcNAQkBFg9y
am9rbEBrZXJpby5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAOaoBCTT3HBiBXgO
t8CiZH8M8+42lPgGe+aEWsD6Kl2tkbZGHleANC8To83N8yyIzxWXaoyVrnkrY6llK1C4ryHn
kcKHmEwr2f3WR3JVTcwMNpE4Ynd549BC3s7iQlZmRZZWerCDtdBbhYBDQZBKTL+izwP6qWqi
SnhjuQYzhc/pAgMBAAGjggK2MIICsjAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIF4DAg
BgNVHSUBAf8EFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIwFAYJYIZIAYb4QgEBAQH/BAQDAgWg
MB0GA1UdDgQWBBTRm+SXjEmCQ8y2itkhBdz4O5MebjCB6AYDVR0jBIHgMIHdgBTuzLLeM/bD
FJMd61exu7g78G7ygaGBwaSBvjCBuzELMAkGA1UEBhMCQ1oxFzAVBgNVBAgTDkN6ZWNoIFJl
cHVibGljMQ8wDQYDVQQHEwZQaWxzZW4xGzAZBgNVBAoTEktlcmlvIFRlY2hub2xvZ2llczEe
MBwGA1UECxMVQ2VydGlmaWNhdGUgQXV0aG9yaXR5MSAwHgYDVQQDExdLZXJpbyBUZWNobm9s
b2dpZXMgSW5jLjEjMCEGCSqGSIb3DQEJARYUaG9zdG1hc3RlckBrZXJpby5jb22CAQAwGgYD
VR0RBBMwEYEPcmpva2xAa2VyaW8uY29tMB8GA1UdEgQYMBaBFGhvc3RtYXN0ZXJAa2VyaW8u
Y29tMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHBzOi8vc2VjdXJlLmtlcmlvLmNvbS9waHBraS9p
bmRleC5waHA/c3RhZ2U9ZGxfY3JsMDsGCWCGSAGG+EIBDQQuFixQSFBraS9PcGVuU1NMIEdl
bmVyYXRlZCBQZXJzb25hbCBDZXJ0aWZpY2F0ZTAuBglghkgBhvhCAQIEIRYfaHR0cHM6Ly9z
ZWN1cmUua2VyaW8uY29tL3BocGtpLzAjBglghkgBhvhCAQMEFhYUbnNfcmV2b2tlX3F1ZXJ5
LnBocD8wOQYJYIZIAYb4QgEIBCwWKmh0dHBzOi8vc2VjdXJlLmtlcmlvLmNvbS9waHBraS9w
b2xpY3kuaHRtbDANBgkqhkiG9w0BAQUFAAOBgQCGFPSbHZeZ7NAQgNLcJvhNAfqAMPwhDAd4
x4uqrExsNVp6zJTQjpS7P8d/iupH8SrkkZeK7t2yYgKNoKhhy1jbmcUJeWpVkHxnQnr6Di+n
N8e/ghR2fOS93ULPCAImxOdK/RQ7VPNkuRi45765pzA8zIiBDJsIV0P1DD0zu+T3ozGCA+kw
ggPlAgEBMIHDMIG7MQswCQYDVQQGEwJDWjEXMBUGA1UECBMOQ3plY2ggUmVwdWJsaWMxDzAN
BgNVBAcTBlBpbHNlbjEbMBkGA1UEChMSS2VyaW8gVGVjaG5vbG9naWVzMR4wHAYDVQQLExVD
ZXJ0aWZpY2F0ZSBBdXRob3JpdHkxIDAeBgNVBAMTF0tlcmlvIFRlY2hub2xvZ2llcyBJbmMu
MSMwIQYJKoZIhvcNAQkBFhRob3N0bWFzdGVyQGtlcmlvLmNvbQIDEASpMAkGBSsOAwIaBQCg
ggJ7MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE3MDQyODA5
MDQ0MlowIwYJKoZIhvcNAQkEMRYEFLd9ZXv4nItq3L0cXC+fJvtqt0+pMGwGCSqGSIb3DQEJ
DzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0D
AgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgdQGCSsGAQQB
gjcQBDGBxjCBwzCBuzELMAkGA1UEBhMCQ1oxFzAVBgNVBAgTDkN6ZWNoIFJlcHVibGljMQ8w
DQYDVQQHEwZQaWxzZW4xGzAZBgNVBAoTEktlcmlvIFRlY2hub2xvZ2llczEeMBwGA1UECxMV
Q2VydGlmaWNhdGUgQXV0aG9yaXR5MSAwHgYDVQQDExdLZXJpbyBUZWNobm9sb2dpZXMgSW5j
LjEjMCEGCSqGSIb3DQEJARYUaG9zdG1hc3RlckBrZXJpby5jb20CAxAEqTCB1gYLKoZIhvcN
AQkQAgsxgcaggcMwgbsxCzAJBgNVBAYTAkNaMRcwFQYDVQQIEw5DemVjaCBSZXB1YmxpYzEP
MA0GA1UEBxMGUGlsc2VuMRswGQYDVQQKExJLZXJpbyBUZWNobm9sb2dpZXMxHjAcBgNVBAsT
FUNlcnRpZmljYXRlIEF1dGhvcml0eTEgMB4GA1UEAxMXS2VyaW8gVGVjaG5vbG9naWVzIElu
Yy4xIzAhBgkqhkiG9w0BCQEWFGhvc3RtYXN0ZXJAa2VyaW8uY29tAgMQBKkwDQYJKoZIhvcN
AQEBBQAEgYBtVCRc7g1MGkeUxj01kRa9xBUXl5DZii4Dq5uyQkOEG6gwYafkpMGkmpmd484+
vw9qSxE54eUzs8gbHxcgIMooxTtpOjDh+nlCZm0xnQ0yGM9A8ZjrUb1O7PsafgKmXyjEdTWI
CVC9KdSKny3DjQcF6L7JD6aS2lcGZfXbRnzyfQAAAAAAAA==
--------------ms080509090201060403080002--
