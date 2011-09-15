Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9520 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934532Ab1IOTi4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:38:56 -0400
Subject: Re: [PATCH 08/27] iwlagn: beautify the code - remove uneeded line
 break
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Joe Perches <joe@perches.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
In-Reply-To: <1316115470.11236.1.camel@Joe-Laptop>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1316112414-6341-9-git-send-email-wey-yi.w.guy@intel.com>
	 <1316115470.11236.1.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 11:53:49 -0700
Message-ID: <1316112830.19293.4.camel@wwguy-huron> (sfid-20110915_213858_578244_E5E6C795)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 12:37 -0700, Joe Perches wrote:
> On Thu, 2011-09-15 at 11:46 -0700, Wey-Yi Guy wrote:
> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Two lines could be concatenated without exceeding the 80 char limit.
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
> []
> > @@ -308,10 +308,8 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
> >  
> >  	txq->q.n_window = slots_num;
> >  
> > -	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num,
> > -			    GFP_KERNEL);
> > -	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num,
> > -			   GFP_KERNEL);
> > +	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num, GFP_KERNEL);
> > +	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num, GFP_KERNEL);
> 
> kcalloc would be even prettier...
> 
> 
agree, would you mind submit a patch to changes it

Thanks
Wey


