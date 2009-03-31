Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:59292 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbZCaRio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 13:38:44 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3289894wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 10:38:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0903311018u104ea3c4x165829ade89b2e76@mail.gmail.com>
References: <200903311159.57449.rossi.f@inwind.it> <40f31dec0903311018u104ea3c4x165829ade89b2e76@mail.gmail.com>
Date: Tue, 31 Mar 2009 10:38:28 -0700
Message-ID: <43e72e890903311038k194c3b5ak52be73c86f153789@mail.gmail.com> (sfid-20090331_193848_151652_1014DD01)
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix interpolation with equal power
	levels
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Fabio Rossi <rossi.f@inwind.it>, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 31, 2009 at 10:18 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2009/3/31 Fabio Rossi <rossi.f@inwind.it>:
>> When the EEPROM contains weird values for the power levels we have to
>> fix the interpolation process.
>>
>> Signed-off-by: Fabio Rossi <rossi.f@inwind.it>

> Acked-by: Nick Kossifidis <mickflemm@gmail.com>

Can this be rebased on top of the ath5k/ath9k/ar9170 merge series?

  Luis
