Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f173.google.com ([209.85.221.173]:55765 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZGWGBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 02:01:00 -0400
Received: by qyk3 with SMTP id 3so986184qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 23:01:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907222244x50bb7c0vb5ac6e6f0cfaea44@mail.gmail.com>
References: <20090723052735.GA5943@myhost.users.atheros.com>
	 <43e72e890907222244x50bb7c0vb5ac6e6f0cfaea44@mail.gmail.com>
Date: Thu, 23 Jul 2009 11:30:59 +0530
Message-ID: <8e92b4100907222300v43e375b1k4e089b5615b08ea@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath9k: Add init values for AR9287 based chipsets.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 11:14 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Wed, Jul 22, 2009 at 10:27 PM, Vivek Natarajan<vivek.natraj@gmail.com> wrote:
>> static const u_int32_t ar9287PciePhy_AWOW_9287_1_0[][2] = {
>
> Unused? and if so, #ifdef CONFIG_PM them ?
Shall I remove them now? and then if WoW comes in, we can include these.

Vivek.
