Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41950 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab2K1UbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:31:21 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so10850281iea.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 12:31:21 -0800 (PST)
Message-ID: <50B67492.7070404@lwfinger.net> (sfid-20121128_213125_960315_9301DC85)
Date: Wed, 28 Nov 2012 14:31:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Daniel Stamer <daniel@stamer.info>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192se: Fixed coding style issues
References: <1354132879-5154-1-git-send-email-daniel@stamer.info>
In-Reply-To: <1354132879-5154-1-git-send-email-daniel@stamer.info>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/28/2012 02:01 PM, Daniel Stamer wrote:
> This patch fixes coding style issues in the whole rtl8192se driver. All rules
> are used, except for the one which demands empty last lines on block comments.
> Some fields have been altered to create readable lines in 80 columns.
>
> Signed-off-by: Daniel Stamer <daniel@stamer.info>

This patch does not apply against either the wireless-next or wireless-testing 
git trees. I could "force" it with wiggle, but John will not, and should not, 
need to do that. What source tree did you use?

Larry


