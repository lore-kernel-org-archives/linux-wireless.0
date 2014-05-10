Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:36937 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaEJRY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2014 13:24:56 -0400
Received: by mail-oa0-f50.google.com with SMTP id i7so6421711oag.23
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2014 10:24:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399742049-31810-1-git-send-email-zajec5@gmail.com>
References: <1399733088-26607-1-git-send-email-zajec5@gmail.com>
	<1399742049-31810-1-git-send-email-zajec5@gmail.com>
Date: Sat, 10 May 2014 19:24:56 +0200
Message-ID: <CACna6ryFO2QzT4OTxRiOwcaT_DBFJCtKU4VRg2HqEMO_91+seA@mail.gmail.com> (sfid-20140510_192459_777502_B4DD5787)
Subject: Re: [PATCH V2] b43: drop SSB dependency
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 May 2014 19:14, Rafał Miłecki <zajec5@gmail.com> wrote:
> This adds choice submenu "Supported bus types" as two simple bool
> configs would allow user to compile b43 without any bus support
> (prety useless).

John: please make sure this one goes *after*
[PATCH V2] b43: adjust code to compile without SSB

I could do better and send it as a patchset, my bad, sorry.
