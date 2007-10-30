Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:35731 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbXJ3Puc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 11:50:32 -0400
Received: by py-out-1112.google.com with SMTP id u77so3616685pyb
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2007 08:50:29 -0700 (PDT)
Message-ID: <43e72e890710300850r72bf96a3ne2c9f3d817d51a29@mail.gmail.com> (sfid-20071030_155035_965530_48739C32)
Date: Tue, 30 Oct 2007 11:50:28 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: [ath5k-devel] MadWifi HAL register dumps - help reverse engineering
Cc: ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	madwifi-devel <madwifi-devel@lists.sourceforge.net>
In-Reply-To: <200710301749.32236.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890710191255k72c7176fx10592dcfc02cb287@mail.gmail.com>
	 <200710301749.32236.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/07, bruno randolf <bruno@thinktube.com> wrote:
> hi luis!
>
> adding the following patch lets us log the calling function names as well!
> which makes it much easier to make sense to the traces :)
>
> and i added ALQ=1 MMIOTRACE=1 and the objdump command to the Makefile as well
> to avoid forgetting that.
>
> cheers,
> bruno
>
> this time the patch is included, sorry...

Nice, how about we start an svn branch on madwifi with this stuff, it
might be easier for users. I understand the current instructions are
pretty involved.

  Luis
