Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245AbXK0QSU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 11:18:20 -0500
Subject: Re: Please pull 'upstream-jgarzik' branch of wireless-2.6
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200711271708.54801.hs4233@mail.mn-solutions.de>
References: <20071127144748.GA12408@tuxdriver.com>
	 <200711271708.54801.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 11:12:55 -0500
Message-Id: <1196179975.5194.7.camel@localhost.localdomain> (sfid-20071127_161824_522873_41AAC2BD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-11-27 at 17:08 +0100, Holger Schurig wrote:
> > A slew of patches for 2.6.25...
> 
> You should consider my patch with the subject
> 
>    [PATCH] libertas: let more than one MAC event through
> 
> as well. As Dan Williams doesn't have the hardware, he can't 
> really ack or nack this patch anyway :-)

I can ack it insofar as it's a 1-liner and doesn't look like it'll screw
a lot of stuff up :)  But then again it's dealing with hardware bits.  I
do have an 8385 CF card on the way though.

Dan

> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

