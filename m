Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:47024 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3CZTgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 15:36:42 -0400
MIME-Version: 1.0
Date: Tue, 26 Mar 2013 12:36:42 -0700
Message-ID: <CAC_eAnVSYjiVw+XyZH-guwtBh82x=OEc3A7PXyK+aHb5V1Cq8A@mail.gmail.com> (sfid-20130326_203647_614184_ABF1031F)
Subject: Losing connection when using rtlwifi
From: Benjamin Byington <benbyington84@gmail.com>
To: backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm currently having issues when using the backported rtlwifi driver set.
 I'm running Fedora 17 and have the wireless chipset RTL8723.  Until
recently I've just been using an unofficial driver provided by realtek, but
that driver fails to compile starting with kernel versions 3.7 and on, so
since then I've been using various versions of backports as they come out.
 I'm currently on kernel version 3.8.3 with compat-drivers-3.9-rc2.

When connecting to my home networks, with WPA encryption, then the drivers
work fine.  When I connect to my campus network, which requires no password
to connect to the router, but does require you to sign in on their webpage
before the general net can be accessed, then I can connect initially,
navigate and download files for a couple minutes, and then all connection
cuts out.  Trying to reconnect, or disabling and then re-enabling the wifi
does not help.  The unofficial driver provided by realtek did not have this
problem.

Here is where I quickly become useless; I don't know diddly squat about
networks, and I don't even have a notion of how to give you useful
information about what is actually failing on my machine.  I'm perfectly
fine with keeping my 3.6 kernel version around if necessary, and I'm mostly
reporting problems to help others find bugs.  If there are any diagnostic
actions that would be useful then please tell me and I'll execute them.  If
I should report a bug with people actually maintaining the drivers code (I
assume it's not an actual backports bug) then please tell me where to to
that.

Thanks,

~Ben
