Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37358 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbbCAWVK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 17:21:10 -0500
Received: by wivr20 with SMTP id r20so10952375wiv.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Mar 2015 14:21:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425238304-498-8-git-send-email-emmanuel.grumbach@intel.com>
References: <1425238186.30202.5.camel@egrumbacBox> <1425238304-498-8-git-send-email-emmanuel.grumbach@intel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 2 Mar 2015 09:20:48 +1100
Message-ID: <CAGRGNgX2r+uLv8CBJwf8LK_3NdtDoiFqqpcS2sRckjJykbNxbg@mail.gmail.com> (sfid-20150301_232219_639456_1EF838D7)
Subject: Re: [PATCH 08/31] iwlwifi: mvm: rs: print single stream params via debugfs
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

On Mon, Mar 2, 2015 at 6:31 AM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> From: Eyal Shapira <eyal@wizery.com>
>
> Add this to the info printed when reading rate_scale_table.
> Useful for debugging.
>
> Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This signoff chain doesn't look right to me (however other people
might not care): Shouldn't Eyal have used their intel.com email
address in the author field?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
