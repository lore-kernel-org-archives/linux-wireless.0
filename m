Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46644 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1FNOhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 10:37:17 -0400
Received: by fxm17 with SMTP id 17so3730208fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 07:37:16 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: ShawnG <swggator4@gmail.com>
Subject: Re: DWA-160
Date: Tue, 14 Jun 2011 16:37:54 +0200
Cc: linux-wireless@vger.kernel.org
References: <BANLkTim0mV230taAmbTm_Rm0wfPBGAznhw@mail.gmail.com> <201106141612.11117.chunkeey@googlemail.com> <BANLkTikcuXeR+iCFXSCzh+tmPDXqhLo2ag@mail.gmail.com>
In-Reply-To: <BANLkTikcuXeR+iCFXSCzh+tmPDXqhLo2ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201106141637.54930.chunkeey@googlemail.com> (sfid-20110614_163721_747656_B663EDCC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 June 2011 16:17:40 ShawnG wrote:

> Is it ok to assume then that future work on CARL9170 will be minimal?
I'm thinking of adding support for cfg80211's new wakeup-on-wlan triggers
and some code to do clear channel assessments in the future. Also, some
resources will probably go into the userspace carlu code as well. So it
answer depends whenever you are interested in those topics or not.

Regards,
	Christian
