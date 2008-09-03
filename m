Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53701 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYICAaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 20:30:24 -0400
Date: Tue, 2 Sep 2008 20:00:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, Ian Schram <ischram@telenet.be>,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-09-02
Message-ID: <20080903000022.GB2964@tuxdriver.com> (sfid-20080903_023027_550237_4EC190AC)
References: <20080902221511.GH3050@tuxdriver.com> <1ba2fa240809021607s6855d3d3p411f13a940271f07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240809021607s6855d3d3p411f13a940271f07@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 03, 2008 at 02:07:27AM +0300, Tomas Winkler wrote:
> > John W. Linville (1):
> >      iwlwifi: do not use GFP_DMA in iwl_tx_queue_init
> This one should be already in Yi's queue.The patch also address the
> allocation error path. It's coauthored with Ian (out of Intel) so we
> send it out just for record ... not sure what's the protocol.

Either rebase it or send it as-is -- I'm sure I can resolve the
conflict.  I just don't see much point in waiting to resolve such a
simple issue.

John
