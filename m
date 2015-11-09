Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:33941 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbbKIPi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 10:38:57 -0500
Received: by qgeb1 with SMTP id b1so92907127qge.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 07:38:56 -0800 (PST)
Date: Mon, 9 Nov 2015 10:38:44 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Yin, Fengwei" <fengwei.yin@linaro.org>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
Subject: Re: [PATCH 2/5] wcn36xx: swallow two wcn3620 IND messages
Message-ID: <20151109153844.GC5395@localhost> (sfid-20151109_163900_644881_D647F406)
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
 <1447063362-27322-3-git-send-email-fengwei.yin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447063362-27322-3-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 09, 2015 at 05:02:39AM -0500, Yin, Fengwei wrote:
> v2: used one break for both in the second stanza

^^^ this

> 
> Signed-off-by: Andy Green <andy.green@linaro.org>
> ---

  ^^^
... should go here (after the ---), so that it doesn't appear in the final
changelog.

-- 
Bob Copeland %% http://bobcopeland.com/
