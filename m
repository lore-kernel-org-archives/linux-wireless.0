Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53759 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYDRLKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 07:10:05 -0400
Subject: Re: [PATCH] libertas: Fix ethtool statistics
From: David Woodhouse <dwmw2@infradead.org>
To: Sebastian Siewior <liber+tas@ml.breakpoint.cc>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, libertas-dev@lists.infradead.org
In-Reply-To: <20080417194437.GA18291@Chamillionaire.breakpoint.cc>
References: <1208448814.9212.270.camel@pmac.infradead.org>
	 <1208455363.20193.3.camel@localhost.localdomain>
	 <20080417194437.GA18291@Chamillionaire.breakpoint.cc>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 12:09:50 +0100
Message-Id: <1208516990.9212.319.camel@pmac.infradead.org> (sfid-20080418_121014_273858_90A58313)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-04-17 at 21:44 +0200, Sebastian Siewior wrote:
> * Dan Williams | 2008-04-17 14:02:43 [-0400]:
> 
> >On Thu, 2008-04-17 at 17:13 +0100, David Woodhouse wrote:
> >> We removed CMD_MESH_ACCESS from the big case statements and provided
> >> lbs_mesh_access() instead.... but we missed one user. Fix it.
> >> 
> >> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> >
> >Acked-by: Dan Williams <dcbw@redhat.com>
> Hmmm. This patch actually reminds me of something I was going to do. I
> don't really see the big difference between this and [1]. I have to
> exert myself to get on your auto-ack list...

Yes, your patch is better than mine because it also zeroes the stats in
the error case. Although we should avoid that error, really.

-- 
dwmw2

