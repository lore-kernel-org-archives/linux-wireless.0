Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:15726 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbXI0Edb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 00:33:31 -0400
Date: Wed, 26 Sep 2007 21:32:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH] iwlwifi: replacing IPW with IWL in error messages
Message-Id: <20070926213238.f49098ca.randy.dunlap@oracle.com>
In-Reply-To: <11908636662994-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
	<11908636662994-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 27 Sep 2007 11:27:30 +0800 Zhu Yi wrote:

> This patch repaces IPW with IWL in error messages.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +++---
>  drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)


meta-comment:  Please have git-send-mail put mail/patch numbers
in each subject line, like

[PATCH 1/14]
  [PATCH 2/14]
    ...

Thanks.
---
~Randy
Phaedrus says that Quality is about caring.
