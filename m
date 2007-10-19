Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:45995 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936882AbXJSTvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 15:51:53 -0400
Received: by py-out-1112.google.com with SMTP id u77so1164694pyb
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2007 12:51:52 -0700 (PDT)
Message-ID: <43e72e890710191251o147d414ycef49847a7a3f957@mail.gmail.com> (sfid-20071019_205221_402202_C9BF2C92)
Date: Fri, 19 Oct 2007 15:51:51 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: AR5418 abgn part?
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <1192808570.6104.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192808570.6104.11.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/19/07, Dan Williams <dcbw@redhat.com> wrote:
> Anyone working on this part or is there just not enough bandwidth?  It's
> completely unrecognized with fairly recent wireless-everything.  I've
> got a machine with one here, would be happy to test stuff if there's
> anything to test.

We will hopefully support this down the road with ath5k. We need
register dumps of the HAL access for this guy. Instructions on how to
do this come next.

  Luis
