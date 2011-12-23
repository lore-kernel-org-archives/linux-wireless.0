Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63492 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab1LWVCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 16:02:06 -0500
Received: by qcqz2 with SMTP id z2so5771870qcq.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 13:02:05 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 24 Dec 2011 02:02:05 +0500
Message-ID: <CADiUXRwb+ktGmyuMxMcXhZkpbhy=kAkOJcTLpJYRcaFFSRMnMg@mail.gmail.com> (sfid-20111223_220211_850241_85F31750)
Subject: Fedora 16 Wireless Connection Problem
From: mammar <mammar@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have Dell Inpiron N5010 with Broadcom Corporation BCM4313
802.11b/g/n Wireless LAN Controller.

My OS is Fedora 16 64-bit. I have installed the following drivers for
my wireless controller, everything is working great until yesterday.
Now whenever i try to connect to wirless connection, it failed.

http://download1.rpmfusion.org/nonfree/fedora/releases/16/Everything/x86_64/os/repoview/broadcom-wl.html

I haven't installed anything that can cause this problem.

Following are log messages from /var/log/messages when i try to
connect to connection. I have double checked connection settings and
everything is correct.

Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Activation
(eth1) starting connection 'Auto Communication Gallery'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> (eth1): device
state change: disconnected -> prepare (reason 'none') [30 40 0]
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Activation (eth1) starting connection 'Auto Communication
Gallery'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> (eth1): device state change: disconnected -> prepare (reason
'none') [30 40 0]
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Activation
(eth1) Stage 1 of 5 (Device Prepare) scheduled...
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Activation (eth1) Stage 1 of 5 (Device Prepare) scheduled...
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Activation
(eth1) Stage 1 of 5 (Device Prepare) started...
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Activation (eth1) Stage 1 of 5 (Device Prepare) started...
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Activation
(eth1) Stage 2 of 5 (Device Configure) scheduled...
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Activation
(eth1) Stage 1 of 5 (Device Prepare) complete.
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Activation (eth1) Stage 2 of 5 (Device Configure) scheduled...
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Activation (eth1) Stage 1 of 5 (Device Prepare) complete.
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Activation
(eth1) Stage 2 of 5 (Device Configure) starting...
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Activation (eth1) Stage 2 of 5 (Device Configure) starting...
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> (eth1): device
state change: prepare -> config (reason 'none') [40 50 0]
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> (eth1): device state change: prepare -> config (reason 'none')
[40 50 0]
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Activation
(eth1/wireless): connection 'Auto Communication Gallery' has security,
and secrets exist. No new secrets needed.
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Activation (eth1/wireless): connection 'Auto Communication
Gallery' has security, and secrets exist. No new secrets needed.
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Config: added
'ssid' value 'Communication Gallery'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Config: added 'ssid' value 'Communication Gallery'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Config: added
'scan_ssid' value '1'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Config: added
'key_mgmt' value 'NONE'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Config: added
'wep_key0' value '<omitted>'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Config: added
'wep_tx_keyidx' value '0'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Activation
(eth1) Stage 2 of 5 (Device Configure) complete.
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Config: added 'scan_ssid' value '1'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Config: added 'key_mgmt' value 'NONE'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Config: added 'wep_key0' value '<omitted>'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Config: added 'wep_tx_keyidx' value '0'
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Activation (eth1) Stage 2 of 5 (Device Configure) complete.
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: <info> Config: set
interface ap_scan to 1
Dec 24 00:46:15 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> Config: set interface ap_scan to 1
Dec 24 00:46:16 ma-laptop NetworkManager[1039]: <info> (eth1):
supplicant interface state: inactive -> scanning
Dec 24 00:46:16 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> (eth1): supplicant interface state: inactive -> scanning
Dec 24 00:46:41 ma-laptop NetworkManager[1039]: <warn> Activation
(eth1/wireless): association took too long.
Dec 24 00:46:41 ma-laptop NetworkManager[1039]: <info> (eth1): device
state change: config -> need-auth (reason 'none') [50 60 0]
Dec 24 00:46:41 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<warn> Activation (eth1/wireless): association took too long.
Dec 24 00:46:41 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> (eth1): device state change: config -> need-auth (reason
'none') [50 60 0]
Dec 24 00:46:41 ma-laptop NetworkManager[1039]: <warn> Activation
(eth1/wireless): asking for new secrets
Dec 24 00:46:41 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<warn> Activation (eth1/wireless): asking for new secrets
Dec 24 00:46:41 ma-laptop NetworkManager[1039]: <warn> Couldn't
disconnect supplicant interface: This interface is not connected.
Dec 24 00:46:41 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<warn> Couldn't disconnect supplicant interface: This interface is not
connected.
Dec 24 00:46:41 ma-laptop NetworkManager[1039]: <warn> Couldn't
disconnect supplicant interface: This interface is not connected.
Dec 24 00:46:41 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<warn> Couldn't disconnect supplicant interface: This interface is not
connected.
Dec 24 00:46:43 ma-laptop NetworkManager[1039]: <info> (eth1):
supplicant interface state: scanning -> inactive
Dec 24 00:46:43 ma-laptop NetworkManager[1039]: NetworkManager[1039]:
<info> (eth1): supplicant interface state: scanning -> inactive
Dec 24 00:46:52 ma-laptop NetworkManager[1039]: <warn> No agents were
available for this request.

Can anyone help me?

Thanks
