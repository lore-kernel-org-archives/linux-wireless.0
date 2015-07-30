Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36837 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbbG3BNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 21:13:37 -0400
Received: by ioeg141 with SMTP id g141so39315370ioe.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2015 18:13:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1438205790-17629-1-git-send-email-hauke@hauke-m.de>
References: <1438205790-17629-1-git-send-email-hauke@hauke-m.de>
Date: Thu, 30 Jul 2015 03:13:36 +0200
Message-ID: <CACna6rwoUVn2YzDOfHrVXg3tU9yVT_1zaDQcySk0ykZjrLLmpA@mail.gmail.com> (sfid-20150730_031343_322666_9D941283)
Subject: Re: [PATCH] b43: fix extpa_gain check for 2GHz
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: kvalo@qca.qualcomm.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 July 2015 at 23:36, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On the 2GHz and and on the 5GHZ band only the extpa_gain setting from
> the 5GHz band was checked. this patch makes it check the property from
> the correct band.

Looks OK, thanks.
