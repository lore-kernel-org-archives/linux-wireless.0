Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44307 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab0JFNaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 09:30:07 -0400
Date: Wed, 6 Oct 2010 09:23:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Manu Bansal <manub686@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211 functionality
Message-ID: <20101006132353.GB2472@tuxdriver.com>
References: <AANLkTim-W8gs3UOuavAgxfurnFfH3R7M8ZJF_F-n_LFO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTim-W8gs3UOuavAgxfurnFfH3R7M8ZJF_F-n_LFO@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 05, 2010 at 05:17:15PM -0700, Manu Bansal wrote:

> I am trying to do a soft-radio implementation on linux using mac80211
> for the parts of 802.11 MAC it implements. It appears that it does not
> do the whole MAC, instead only the MLME portion of it, and the core
> functions of carrier sensing, backoff etc are still in
> firmware/hardware. Is this understanding correct? Are the mac80211
> book and code the best references to understand this split of
> functionality, or there is a more complete/concise reference?

I think you read it correctly.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
