Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:41321 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbZBZAba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 19:31:30 -0500
Message-ID: <49A5E2DE.2070705@lwfinger.net> (sfid-20090226_013133_902158_01BD04AB)
Date: Wed, 25 Feb 2009 18:31:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
CC: Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Latest test  with open-source firmware
References: <49A56B1F.80702@lwfinger.net> <7B2FC6CE-4169-480A-B5D5-5CC7CECACEF4@ing.unibs.it>
In-Reply-To: <7B2FC6CE-4169-480A-B5D5-5CC7CECACEF4@ing.unibs.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Francesco Gringoli wrote:
> Larry, (pardon me if you answered this question) have you tried to see
> what happens with the halved queue when using the open firmware?

The above test was with open firmware V5.1. Sorry if I didn't make that clear.

The current test has been running for 9 hours with RX queue depth of 64 and TX
queue depth of 32. The biggest depth of the TX status queue so far has been 12.

FWIW, the longest the test has run previously without crashing has been 7 hours.

Larry
