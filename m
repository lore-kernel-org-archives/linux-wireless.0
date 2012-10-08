Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab2JHJQ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 05:16:59 -0400
Date: Mon, 8 Oct 2012 11:15:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/7] rt2800: use BBP_R1 for setting tx
 power
Message-ID: <20121008091523.GB2478@redhat.com> (sfid-20121008_111703_432490_9F610AD6)
References: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
 <506F0A56.70900@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <506F0A56.70900@01019freenet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Fri, Oct 05, 2012 at 06:27:02PM +0200, Andreas Hartmann wrote:
> I would like to test this patchset. Whereon should I pay (most)
> attention? What do you expect to be changed (or not) behaviour with 2.4
> GHz / 40 MHz?

Yes, all band 2.4GHz/5GHz and bandwitch 20MHz/40MHz combinations are 
touched by those patches. 

You can check if patches make anything better on long distance
performance if you want to.

Thanks
Stanislaw

