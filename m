Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37164 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbcCRTwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 15:52:42 -0400
Received: by mail-wm0-f41.google.com with SMTP id p65so51492489wmp.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 12:52:40 -0700 (PDT)
Subject: Re: pull request: iwlwifi-2016-02-16
To: "Coelho, Luciano" <luciano.coelho@intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA13D1A@hasmsx107.ger.corp.intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <56EC5C83.6070708@broadcom.com> (sfid-20160318_205245_981585_99B650D8)
Date: Fri, 18 Mar 2016 20:52:35 +0100
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA13D1A@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-2-2016 12:57, Grumbach, Emmanuel wrote:
> * Luca fixes a very visible bug in scheduled scan: our firmware
>   doesn't support scheduled scan with no profile configured and
>   the supplicant sometimes requests such scheduled scans.

Hi Luca,

I have seen this happening as well, but did not find the exact scenario
in which supplicant does this. Would you happen to know?

Regards,
Arend
