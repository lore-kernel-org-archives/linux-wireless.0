Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:33857 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbZFCSVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:21:35 -0400
Received: by gxk10 with SMTP id 10so272623gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2009 11:21:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <45e8e6c40906020958x3de155acx1011452051c9e96@mail.gmail.com>
References: <661650.46971.qm@web55304.mail.re4.yahoo.com>
	 <45e8e6c40906020958x3de155acx1011452051c9e96@mail.gmail.com>
Date: Wed, 3 Jun 2009 21:21:33 +0300
Message-ID: <40f31dec0906031121xfb76641h3137f53ed5c8a792@mail.gmail.com>
Subject: Re: ath9k/ath5k + 80211s crash
From: Nick Kossifidis <mickflemm@gmail.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: austinxxh-ath9k@yahoo.com, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/2 Andrey Yurovsky <andrey@cozybit.com>:
> With wireless-testing from a couple of days ago, an X86 system, and this patch:
> http://osdir.com/ml/linux-wireless/2009-05/msg01241.html
> ath9k can bring up a mesh point interface and doesn't crash for me,
> but there are no mesh beacons, so mesh isn't working.  On ath5k, there
> are also no beacons and mesh doesn't work, but there's no crash.
>


Hmm, try adding NL80211_IFTYPE_MESH_POINT here ->

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/pcu.c;h=ec35503f6a40e6b6a1cc4323287b31e7cdd3a428;hb=HEAD#l733

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
