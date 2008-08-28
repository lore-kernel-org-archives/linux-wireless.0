Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41732 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYH1Lxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:53:43 -0400
Subject: Re: [PATCH 04/11] iwlwifi: remove false rxon if rx chain changes
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>
In-Reply-To: <1ba2fa240808280406y4056a8bfufcd09f9b976e1074@mail.gmail.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219926653.6064.13.camel@californication>
	 <1ba2fa240808280406y4056a8bfufcd09f9b976e1074@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 15:53:39 +0200
Message-Id: <1219931619.6064.45.camel@californication> (sfid-20080828_135347_140654_45CDDF49)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas,

> >> Rx chain might change during power save transitions but it doesn't
> >> requires full rxon. The patch avoids the rxon by removing the rx_chain
> >> check.
> >
> > and again. Is this a regression. What is the down side or impact from
> > not doing this. Did we used to do it different in 2.6.26?
> 
> Yes this one is regression this is new code and causes disconnection.

please put this into the commit messages. And then it should go in.

Regards

Marcel


