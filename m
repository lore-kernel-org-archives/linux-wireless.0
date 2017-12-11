Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:47124 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752572AbdLKMQG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 07:16:06 -0500
Message-ID: <1512994564.26976.75.camel@sipsolutions.net> (sfid-20171211_131610_463629_1C41FEC3)
Subject: Re: [PATCH v2 4/5] mac80211_hwsim: add permanent mac address option
 for new radios
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Dec 2017 13:16:04 +0100
In-Reply-To: <e963dbdc-7be7-4779-b3c7-2dedc2a7451a@MAIL2.uni-rostock.de>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
         <e963dbdc-7be7-4779-b3c7-2dedc2a7451a@MAIL2.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-11-21 at 13:17 +0100, Benjamin Beichler wrote:
> 
> + * @HWSIM_ATTR_TX_INFO_FLAGS: additional flags for corresponding
> + *	rates of %HWSIM_ATTR_TX_INFO

> +	HWSIM_ATTR_TX_INFO_FLAGS,

This should be in the next patch

johannes
