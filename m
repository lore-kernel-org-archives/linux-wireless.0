Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:3126 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932273Ab2GAMBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 08:01:35 -0400
Message-ID: <1341144092.1911.95.camel@x61.thuisdomein> (sfid-20120701_140138_925115_311115AA)
Subject: Re: [RFT] iwlegacy: don't mess up the SCD when removing a key
From: Paul Bolle <pebolle@tiscali.nl>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Sun, 01 Jul 2012 14:01:32 +0200
In-Reply-To: <1341148023-17673-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1341148023-17673-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel,

On Sun, 2012-07-01 at 16:07 +0300, Emmanuel Grumbach wrote:
> Paul, can you please test ?

Sure, and thanks for porting that patch.

> If it solve the issues for you, I will send as a patch and Cc stable
> Totally not tested

Note that it might take some days, maybe even a week, before I can be
confident that the patch works. Perhaps I should give suspending and
resuming in a loop a try, that should speed up testing.


Paul Bolle

