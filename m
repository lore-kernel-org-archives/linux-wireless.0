Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60464 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0J3AAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 20:00:07 -0400
Received: by gxk23 with SMTP id 23so2329673gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 17:00:06 -0700 (PDT)
Message-ID: <4CCB601A.9010909@lwfinger.net>
Date: Fri, 29 Oct 2010 19:00:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: seno <senada@t-online.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com> <4C798080.8010002@lwfinger.net> <20100830141218.GB30864@tuxdriver.com> <4C7BC4D9.1010108@lwfinger.net> <20100830152841.GB2950@barata.holoscopio.com> <loom.20101026T200014-691@post.gmane.org> <4CC71CFF.8050004@lwfinger.net> <20101026185341.GA4608@barata.holoscopio.com> <20101028191305.2960c83b@gotham.conectiva> <loom.20101029T010426-834@post.gmane.org> <20101029135449.GB3768@barata.holoscopio.com> <loom.20101030T001241-932@post.gmane.org>
In-Reply-To: <loom.20101030T001241-932@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/2010 05:31 PM, seno wrote:
> I noticed that the connection is fast for a short time after booting (10 mbit @ 
> 10 meters), but a few seconds after the download on speedtest.net started 
> (meaning the network gets under load), speed drops to 1 mbit and never recovers 
> to faster speed again; somehow like an "unrecoverable fallback mechanism"...?

Is your device overheating?
