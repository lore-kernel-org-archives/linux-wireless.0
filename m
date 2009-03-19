Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:21933 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZCSGKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 02:10:30 -0400
Received: by wf-out-1314.google.com with SMTP id 29so487709wff.4
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 23:10:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237442241-29803-1-git-send-email-lrodriguez@atheros.com>
References: <1237442241-29803-1-git-send-email-lrodriguez@atheros.com>
Date: Wed, 18 Mar 2009 23:10:28 -0700
Message-ID: <43e72e890903182310o58cf15f9yeeba8c86c45627d7@mail.gmail.com> (sfid-20090319_071033_987418_7147E5F7)
Subject: Re: [PATCH] iw: add support to print HT40-/+ on channels
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 18, 2009 at 10:57 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> You don't have to guess now if your channels support HT40-/+ now.
> This also helps with regulatory testing.

Oh and here's a screenshot:

When a country doesn't allow HT40 at all, you'll see:

                Frequencies:
                        * 2412 MHz [1] (27.0 dBm / 20 MHz) (HT40 disallowed)
                        * 2417 MHz [2] (27.0 dBm / 20 MHz) (HT40 disallowed)
                        * 2422 MHz [3] (27.0 dBm / 20 MHz) (HT40 disallowed)
                        * 2427 MHz [4] (27.0 dBm / 20 MHz) (HT40 disallowed)
                        * 2432 MHz [5] (27.0 dBm / 20 MHz) (HT40 disallowed)
                        * 2437 MHz [6] (27.0 dBm / 20 MHz) (HT40 disallowed)
                        * 2442 MHz [7] (27.0 dBm / 20 MHz) (HT40 disallowed)
                        * 2447 MHz [8] (27.0 dBm / 20 MHz) (HT40 disallowed)
                        * 2452 MHz [9] (27.0 dBm / 20 MHz) (HT40 disallowed)
                        * 2457 MHz [10] (27.0 dBm / 20 MHz) (HT40 disallowed)
                        * 2462 MHz [11] (27.0 dBm / 20 MHz) (HT40 disallowed)
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
                        * 2484 MHz [14] (disabled)

When HT40 is allowed but due to band edges either HT40- or HT4+ is not allowed:

                Frequencies:
                        * 2412 MHz [1] (27.0 dBm / 20 MHz) (HT40- disallowed)
                        * 2417 MHz [2] (27.0 dBm / 20 MHz) (HT40- disallowed)
                        * 2422 MHz [3] (27.0 dBm / 20 MHz) (HT40- disallowed)
                        * 2427 MHz [4] (27.0 dBm / 20 MHz) (HT40- disallowed)
                        * 2432 MHz [5] (27.0 dBm / 20 MHz)
                        * 2437 MHz [6] (27.0 dBm / 20 MHz)
                        * 2442 MHz [7] (27.0 dBm / 20 MHz)
                        * 2447 MHz [8] (27.0 dBm / 20 MHz) (HT40+ disallowed)
                        * 2452 MHz [9] (27.0 dBm / 20 MHz) (HT40+ disallowed)
                        * 2457 MHz [10] (27.0 dBm / 20 MHz) (HT40+ disallowed)
                        * 2462 MHz [11] (27.0 dBm / 20 MHz) (HT40+ disallowed)
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
                        * 2484 MHz [14] (disabled)

  Luis
