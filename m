Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:56380 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBIQYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Feb 2014 11:24:37 -0500
Received: by mail-ob0-f178.google.com with SMTP id wn1so6192041obc.37
        for <linux-wireless@vger.kernel.org>; Sun, 09 Feb 2014 08:24:36 -0800 (PST)
Message-ID: <52F7ABC2.30506@lwfinger.net> (sfid-20140209_172502_561003_5D6DCDC8)
Date: Sun, 09 Feb 2014 10:24:34 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Amr Abd Elaziz <amrabdelaziz.mime@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: lubunto 13.10
References: <CA+3akvnV66kn50fA8oVv4oiD9kH+Kzw+CVBJmnyXgA34VjLuzQ@mail.gmail.com>
In-Reply-To: <CA+3akvnV66kn50fA8oVv4oiD9kH+Kzw+CVBJmnyXgA34VjLuzQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2014 08:03 AM, Amr Abd Elaziz wrote:
> i need wireless drive for acer travelmate 2420

Could you please supply more information? Not many of us have that computer, and 
we have no idea what wireless card is in it. In addition, my crystal ball is broken.

If it is a PCI device, the appropriate part of 'lspci -nn' is what we need. If 
it is a USB device, then lsusb output is needed. In addition, 'uname -r' will 
tell use what Linux kernel you are using.

Larry


