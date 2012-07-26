Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40145 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238Ab2GZF0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 01:26:09 -0400
Received: by lahd3 with SMTP id d3so1137807lah.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 22:26:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343267468-9986-1-git-send-email-acelan.kao@canonical.com>
References: <1343267468-9986-1-git-send-email-acelan.kao@canonical.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 26 Jul 2012 15:25:47 +1000
Message-ID: <CAGRGNgWk1wV_6Xi6jQppkBtJ+1TYRpTSQ=v8NZffqSBtJNGBYQ@mail.gmail.com> (sfid-20120726_072613_945239_4FCE18AC)
Subject: Re: [PATCH] Revert "rfkill: remove dead code"
To: AceLan Kao <acelan.kao@canonical.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Corentin Chary <corentincj@iksaif.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi AceLan,

On Thu, Jul 26, 2012 at 11:51 AM, AceLan Kao <acelan.kao@canonical.com> wrote:
> This reverts commit 2e48928d8a0f38c1b5c81eb3f1294de8a6382c68.
>
> Those functions are needed and should not be removed, or
> there is no way to set the rfkill led trigger name.

Who or what is using these functions?

As I understand it, they wouldn't have been removed if any upstream
code was using them.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
