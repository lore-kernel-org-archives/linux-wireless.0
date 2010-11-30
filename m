Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46441 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab0K3Iff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 03:35:35 -0500
Received: by ewy5 with SMTP id 5so2557460ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 00:35:34 -0800 (PST)
Subject: wireless.kernel.org update
From: Thomas Novin <thomas@xyz.pp.se>
Reply-To: thomas@xyz.pp.se
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 30 Nov 2010 09:35:22 +0100
Message-ID: <1291106122.13696.0.camel@thonov-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

This page,
http://wireless.kernel.org/en/users/Download#Getting_compat-wireless_on_Ubuntu, should be updated to include Maverick/10.10.

If I just try to install as instructed for other versions:

sudo apt-get install linux-backports-modules-wireless-lucid-generic

I get:

E: Unable to locate package
linux-backports-modules-wireless-lucid-generic

If I search backports*modules*wireless I find:

linux-backports-modules-wireless-2.6.35-22-generic - compat-wireless
Linux modules for version 2.6.35 on x86/x86_64
linux-backports-modules-wireless-2.6.35-22-generic-pae - compat-wireless
Linux modules for version 2.6.35 on x86
linux-backports-modules-compat-wireless-2.6.36-2.6.35-23-generic -
compat-wireless Linux modules for version 2.6.35 on x86/x86_64
linux-backports-modules-compat-wireless-2.6.36-2.6.35-23-generic-pae -
compat-wireless Linux modules for version 2.6.35 on x86
linux-backports-modules-wireless-maverick-generic - Backported wireless
drivers for generic kernel image
linux-backports-modules-wireless-maverick-generic-pae - Backported
wireless drivers for generic kernel image

So the only package good for installing without having to re-install
every kernel change is
linux-backports-modules-wireless-maverick-generic, however that package
is not installable.

$ sudo apt-get install linux-backports-modules-wireless-maverick-generic
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 linux-backports-modules-wireless-maverick-generic : Depends:
linux-backports-modules-wireless-2.6.35-23-generic but it is not
installable
E: Broken packages

Something is broken in Ubuntu it seems?

Rgds

