Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65524 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1IUOpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 10:45:23 -0400
Received: by gxk6 with SMTP id 6so1186485gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 07:45:23 -0700 (PDT)
Message-ID: <4E79F87F.1050402@lwfinger.net> (sfid-20110921_164526_799875_F068004F)
Date: Wed, 21 Sep 2011 09:45:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chiefdome <chiefdome@googlemail.com>
CC: george0505@realtek.com, linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com>
In-Reply-To: <4E79B1D0.7090602@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2011 04:43 AM, Chiefdome wrote:
> I tried the latest git repo from
> git://git.infradead.org/users/linville/wireless-next.
> Same story here.
> After disconnecting to the network, I have to reload the module only then
> networks are seen.

I just cloned the wireless-next tree. The two patches mentioned in my previous 
Email are included.

Please run the following command sequence and send us the dmesg output after 
your failure occurs:

modprobe -rv rtl8192cu
modprobe -v rtlwifi debug=3
modprobe -v rtl8192cu

Larry
