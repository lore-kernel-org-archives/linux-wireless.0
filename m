Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:45192 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYH1LG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:06:26 -0400
Received: by ey-out-2122.google.com with SMTP id 6so96486eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 04:06:25 -0700 (PDT)
Message-ID: <1ba2fa240808280406y4056a8bfufcd09f9b976e1074@mail.gmail.com> (sfid-20080828_130629_762003_AB2358C4)
Date: Thu, 28 Aug 2008 14:06:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 04/11] iwlwifi: remove false rxon if rx chain changes
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Mohamed Abbas" <mohamed.abbas@intel.com>
In-Reply-To: <1219926653.6064.13.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219926653.6064.13.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 3:30 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Yi,
>
>> Rx chain might change during power save transitions but it doesn't
>> requires full rxon. The patch avoids the rxon by removing the rx_chain
>> check.
>
> and again. Is this a regression. What is the down side or impact from
> not doing this. Did we used to do it different in 2.6.26?

Yes this one is regression this is new code and causes disconnection.
Tomas
