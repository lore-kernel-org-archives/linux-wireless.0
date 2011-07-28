Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42197 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab1G1Ljr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 07:39:47 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QmOwM-0006jU-QZ
	for linux-wireless@vger.kernel.org; Thu, 28 Jul 2011 13:39:46 +0200
Received: from 130.233.194.206 ([130.233.194.206])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 13:39:46 +0200
Received: from swaminathanvasanth.r by 130.233.194.206 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 13:39:46 +0200
To: linux-wireless@vger.kernel.org
From: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Subject: Re: Testing Auto Channel Selection with hostapd in ath5k and ath9k
Date: Thu, 28 Jul 2011 11:39:32 +0000 (UTC)
Message-ID: <loom.20110728T133919-978@post.gmane.org> (sfid-20110728_133950_871429_DDC28738)
References: <CAEzeFio8D9aKDFX+Wzo0yceWXy_5tDKpLDFzr9FmarTXCHUOQg@mail.gmail.com> <CAEzeFirXVu_pwDCb6t=ps4xskc4fFUy9gGECJgK1q7cYhLizVQ@mail.gmail.com> <CAEzeFip+PCV4Ccsi6L+RSvrM_86J2=Ps6193WyC0QzVfwe64LQ@mail.gmail.com> <CAEzeFiq2FXYKkfXjDtguryniaU7hQkJczLU98V9P3Uv5-D-P3g@mail.gmail.com> <CAB=NE6VT_Q5Apb_ZCfK9fSYGDtaUOwmVqeogN8HE6+SgGYek1A@mail.gmail.com> <CAEzeFiq5HXyazJfAx3mRV7TBy6CVEivJY63GkF8jnCczGsUK8Q@mail.gmail.com> <CAB=NE6WaRyX0yGs=6h6+2V+gUSPHoY19TTHuXBRAWqR9hw+qAw@mail.gmail.com> <loom.20110727T230512-90@post.gmane.org> <CAB=NE6WwP+S8f=MFDtuC6a97nZEGak5gfFEy9majqD9KVVSjiw@mail.gmail.com> <CAB=NE6U3wa88Fk03q7u17WtoJP1QmoSgJ4D27GSs0pBYGBuCTw@mail.gmail.com> <CAB=NE6VWE1dvc3s-qJK45xcg5xQ6t+nqmnby_gip6-ahMVFh6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

 It din work :( Though i pointed to the ACS Hostapd git, while building the
firmware it is taking the source code of hostapd without ACS. I need to somehow
point it to ACS enabled hostapd git. I ll try to fix it.

Thanks,
BR,
 Vasanth

