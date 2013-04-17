Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:37789 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966154Ab3DQMec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:34:32 -0400
Received: by mail-ie0-f169.google.com with SMTP id ar20so1843096iec.28
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 05:34:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366200500-4661-3-git-send-email-stf_xl@wp.pl>
References: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
	<1366200500-4661-3-git-send-email-stf_xl@wp.pl>
Date: Wed, 17 Apr 2013 14:34:31 +0200
Message-ID: <CAL1gcdO9z2X5h73K6vgrYQVu6qw80k=zXb9_gR7yX=u3FYHfig@mail.gmail.com> (sfid-20130417_143435_783788_D9C81AB0)
Subject: Re: [PATCH v2 02/11] rt2800: move rf init calibration code
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 17, 2013 at 2:08 PM,  <stf_xl@wp.pl> wrote:
> From: Stanislaw Gruszka <stf_xl@wp.pl>
>
> Add separate function for rf init calibration code and use it
> on all init rf subroutines.
>
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

---
Gertjan
