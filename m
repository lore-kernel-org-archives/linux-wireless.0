Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:41412 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZDUOfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 10:35:03 -0400
Received: by yx-out-2324.google.com with SMTP id 3so1123285yxj.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2009 07:35:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49EDB474.2020809@bitnet.be>
References: <49E71982.5050204@bitnet.be>
	 <40f31dec0904160611l58500309wa1ba92fe3aeff843@mail.gmail.com>
	 <49EDB474.2020809@bitnet.be>
Date: Tue, 21 Apr 2009 10:27:25 -0400
Message-ID: <b6c5339f0904210727j73844962wdc916df74cfc1c5f@mail.gmail.com> (sfid-20090421_163510_302101_6DCD812D)
Subject: Re: how to set antenna iw + ath5k
From: Bob Copeland <me@bobcopeland.com>
To: Hans Maes <Hans@bitnet.be>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 21, 2009 at 7:56 AM, Hans Maes <Hans@bitnet.be> wrote:
> Any pointers where to look for a simple howto on 'the proper way' to apply
> these patches ?  Any idea when this patch would make it into the git
> repository ?

The best way is to collect all the patches together and use git-am(1).
You need the raw patches, and I'm not sure if you can get them from the
ath5k-devel list archive, but as these were cross-posted to linux-wireless,
you can get them from http://marc.info (use the "download message raw"
link).  You generally need the entire series, all 7 patches in this case.
As a last resort, you can ask the patch author to forward you a copy.

Once you have all the patches, you can apply them individually with
git-am, or as a group if you have them in mbox format.  See its manpage
for details.

The usual alternative is "patch -p1 < foo.patch" but it won't create
git commits for you.

The patches should go in pretty soon, the only thing objected to was the
over 80 col changelog.

>>> Please reply to my personal e-mail address as well, I'm not subscribed to
>>> the list.

It is common etiquette on Linux kernel-related mailing lists to simply do
reply-all -- especially on lkml where most people do not subscribe.

-- 
Bob Copeland %% www.bobcopeland.com
