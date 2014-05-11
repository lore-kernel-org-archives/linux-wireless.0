Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53243 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaEKQlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 12:41:19 -0400
Received: by mail-ob0-f174.google.com with SMTP id uz6so7030814obc.5
        for <linux-wireless@vger.kernel.org>; Sun, 11 May 2014 09:41:18 -0700 (PDT)
Message-ID: <536FA82C.1040203@lwfinger.net> (sfid-20140511_184136_435815_3E8C29BD)
Date: Sun, 11 May 2014 11:41:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Kernel binary for RTL8192EE
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This mail is blind copied to everyone that has contacted me regarding a driver 
for the RTL8192EE, and to the Realtek developers.

Although the patches needed to add this driver to the 3.14.X kernel were made 
available earlier, not everyone has the expertise needed to build a kernel for 
their system. As the Lenovo T440s is the only computer that currently is 
shipping with this device, and Lenovo uses Ubuntu 14.04, I have built such a 
patched kernel and I am making is available. This one uses the official 3.13.3 
source currently in use by Ubuntu and includes all of their patches.

The file is obtained at 
http://www.lwfinger.com/realtek_drivers/linux-image-3.13.9_0.9_amd64.deb. At 
present, I do not have a 32-bit version available. After downloading, this 
kernel is installed using the command 'sudo dpkg -i <path_to_downloaded_deb_file>

Larry
