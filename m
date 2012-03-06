Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48923 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965097Ab2CFN12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 08:27:28 -0500
Received: by wgbdr13 with SMTP id dr13so4525089wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 05:27:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1331036818-9240-1-git-send-email-arend@broadcom.com>
References: <1331036818-9240-1-git-send-email-arend@broadcom.com>
Date: Tue, 6 Mar 2012 14:27:27 +0100
Message-ID: <CACna6rx5_wds1gMA+9Yg4hMS1NCankwEqN3ixMUaktLAhw9ERw@mail.gmail.com> (sfid-20120306_142732_759166_8A54A913)
Subject: Re: [RFC] bcma: replace ssb_sprom structure with bcma_sprom structure
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev-list <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/3/6 Arend van Spriel <arend@broadcom.com>:
> BCMA shared a structure with SSB in which sprom data was stored. This
> could have been appropriate but with upcoming srom revisions that are
> of no interest to SSB it is better to have own definitions with BCMA.
>
> This patch adds support for srom revisions 8 and 9.

Does b43 even compile with that?

-- 
Rafał
