Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41545 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab0BBVlm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 16:41:42 -0500
Subject: Re: [PATCH] mac80211: fix deferred hardware scan requests
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1265140183.29119.82.camel@johannes.local>
References: <1265136878-5844-1-git-send-email-reinette.chatre@intel.com>
	 <1265140183.29119.82.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 13:41:41 -0800
Message-ID: <1265146901.2551.1407.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, 2010-02-02 at 11:49 -0800, Johannes Berg wrote:
> I was able to reproduce the problem, and the following seems to fix it
> for me; what do you think?

Thank you very much. This looks good, much cleaner. The code touched
here changed since 2.6.33 ... could you please create a 2.6.33 version
also?

Reinette


