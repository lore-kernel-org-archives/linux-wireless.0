Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165Ab3LDOgn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 09:36:43 -0500
Message-ID: <1386167786.19448.4.camel@dcbw.foobar.com> (sfid-20131204_153646_840198_1E01D059)
Subject: Re: status of libertas_tf + sdio?
From: Dan Williams <dcbw@redhat.com>
To: Andreas Kemnade <andreas@kemnade.info>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Date: Wed, 04 Dec 2013 08:36:26 -0600
In-Reply-To: <20131203202607.0b445195@kemnade.info>
References: <20131203202607.0b445195@kemnade.info>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 20:26 +0100, Andreas Kemnade wrote:
> Hi,
> 
> I want to be able to use my marvel sdio wifi as an ap, so I am interested
> in having the sdio interface of libertas_tf. I sucessfully copied
> over the libertas_tf directory from somewhere and fixed a bit of things
> and compiled that in a 3.7 kernel. It works.
> But now I am thinking about generating a clean patch.
> 
> I found this one here:
> http://www.spinics.net/lists/linux-wireless/msg55245.html
> Is there any newer patch to start working on?

I don't think so.  If you're interested in working on this, great!

Dan

