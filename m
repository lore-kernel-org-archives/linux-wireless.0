Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56788 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab1LGPG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 10:06:58 -0500
Received: by bkbzv3 with SMTP id zv3so542108bkb.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2011 07:06:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EDF71C6.9050800@broadcom.com>
References: <4ED77C85.1050705@broadcom.com>
	<CACna6rznu8d1BjG0EWjP1VRCPdYAGJv1q+fi1X+XF_Bf-Cx+Mg@mail.gmail.com>
	<4EDCE2CC.3060500@broadcom.com>
	<CACna6rwVRrm8YgvoYAmswru8nHXgytuiDRO2F2TQVZyxnfaV9w@mail.gmail.com>
	<4EDF71C6.9050800@broadcom.com>
Date: Wed, 7 Dec 2011 16:06:56 +0100
Message-ID: <CACna6rzQqJ-jeuoYMiyYBTt7tXzYV-noCg_kCmOynBrFBnLn2A@mail.gmail.com> (sfid-20111207_160701_375072_86A4C111)
Subject: Re: bcma usage in isr context
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 7 grudnia 2011 15:01 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> I also intend to do some suspend/resume
> testing. I believe there was some issue mentioned on wireless mailing
> list with bcma/b43.

That would be great. I don't have any notebook to use with Broadcom
card, that's why suspend&resume isn't implemented. I do all
development with my PC. In the notebook wireless card is integrated
with the motherboard.

-- 
Rafał
