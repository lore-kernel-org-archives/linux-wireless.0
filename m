Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48972 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab2BXBjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 20:39:48 -0500
Received: by iacb35 with SMTP id b35so2346361iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 17:39:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329667396-20357-1-git-send-email-sidhayn@gmail.com>
References: <1329667396-20357-1-git-send-email-sidhayn@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 23 Feb 2012 17:39:27 -0800
Message-ID: <CAB=NE6VSR8_uhsoDkgh2SmjgDerSX2CXztt2cVxYTEQSgTaYwg@mail.gmail.com> (sfid-20120224_024001_637352_4959F886)
Subject: Re: [PATCH] [compat-wireless] replace modprobe -l with functional equivilent
To: Rick Farina <sidhayn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 19, 2012 at 8:03 AM, Rick Farina <sidhayn@gmail.com> wrote:
> modprobe -l is either deprecated or removed, so let's replace it
>
> Signed-off-by: Rick Farina <sidhayn@gmail.com>

Did you test this when one of those modules is present?

  Luis
