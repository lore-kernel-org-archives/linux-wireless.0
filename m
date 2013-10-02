Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:64963 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab3JBNHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 09:07:52 -0400
Received: by mail-oa0-f43.google.com with SMTP id f4so722847oah.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 06:07:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380718874.13329.17.camel@jlt4.sipsolutions.net>
References: <1380545557-25103-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1380704100.13329.6.camel@jlt4.sipsolutions.net>
	<CAA2SeN+nhLU7vGDNLJCD=UrNRSFm5hT6HGEEhUqr1kAcMF3O-A@mail.gmail.com>
	<1380708715.13329.16.camel@jlt4.sipsolutions.net>
	<CAA2SeNLFSN0tAyABk=MoFDxS6purc6Tgx6R-U5xhuRJZRCZ6ig@mail.gmail.com>
	<1380718874.13329.17.camel@jlt4.sipsolutions.net>
Date: Wed, 2 Oct 2013 15:07:52 +0200
Message-ID: <CAA2SeNJqL2HwVWXN793nJo+B7ZF+9nhZMHHj2ijyheREA7gP8w@mail.gmail.com> (sfid-20131002_150756_079819_F0F7D45E)
Subject: Re: [PATCH] mac80211: allow mgmt frame transmission on DFS channels
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am testing some personal hostapd changes in order to add CAC/NOP
management using methods added by Simon

2013/10/2 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2013-10-02 at 14:52 +0200, Lorenzo Bianconi wrote:
>> I am not using latest mac80211/hostapd (in particular
>> compat-wireless-2013-04-16/hostapd-20130807) because I have to port
>> some personal stuff. In this scenario I was not able to establish an
>> AP/STA connection on DFS channel. Anyway I will update these packages.
>
> But that old hostapd doesn't support DFS to start with, does it? I'm
> confused.
>
> johannes
>



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
