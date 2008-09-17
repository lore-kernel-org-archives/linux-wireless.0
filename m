Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36794 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYIQXfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 19:35:52 -0400
Subject: Re: iw packaging
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221674779.7412.0.camel@localhost>
References: <1221596962.9262.12.camel@johannes.berg>
	 <1221668590.6782.10.camel@californication>
	 <1221669826.3217.1.camel@localhost>
	 (sfid-20080917_184356_807082_BBB4BA6D)  <1221674779.7412.0.camel@localhost>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 01:36:36 +0200
Message-Id: <1221694596.6782.15.camel@californication> (sfid-20080918_013555_748843_191F858C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > Do you think it'd be worthwhile? I can probably automate that easily on
> > wireless.kernel.org...
> 
> Since it's trivial, I'm now creating release tarballs for every tag on
> http://wireless.kernel.org/iw/.

to make it easier for the packager, I would propose to remove the "v" in
front of the version number.

I know you use that for your tags and using git-describe is so great,
but for packaging the extra character is just in the way.

Otherwise, thanks for putting these up.

Regards

Marcel


