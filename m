Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934444Ab3FSW5Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 18:57:25 -0400
Message-ID: <1371682734.1051.0.camel@dcbw.foobar.com> (sfid-20130620_005728_113441_8DA40BCC)
Subject: Re: Howto remove rfkill from kernel
From: Dan Williams <dcbw@redhat.com>
To: rlwkayaker <rlwkayaker@charter.net>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jun 2013 17:58:54 -0500
In-Reply-To: <20130619133638.3d183a00@compuzoo>
References: <20130619133638.3d183a00@compuzoo>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-19 at 13:36 -0400, rlwkayaker wrote:
> The rfkill "feature" has rendered the internal wireless of my
> Averatec 3260 laptop unusable.  It works fine with earlier
> kernels without this "feature".  How do I remove the rfkill
> "feature" from a custom built kernel?

Best thing to do is figure out why this is happening, and fix it.  What
kernels worked?  What kernels fail?  What wifi card do you have, and was
it the card the laptop originally came with?

Dan

