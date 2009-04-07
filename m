Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:32809 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZDGAGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 20:06:23 -0400
Received: by fxm2 with SMTP id 2so2111972fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2009 17:06:20 -0700 (PDT)
Subject: What is needed to inplement a AP support in a driver?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 03:06:17 +0300
Message-Id: <1239062777.4705.30.camel@maxim-laptop> (sfid-20090407_020641_627468_1583988E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I recently found that now ath5k supports AP mode.
I also found that most of the work is now done in userspace.

Since many drivers including my IWL3945 support sending beacons for IBSS
(strictly speaking userspace can send them too, but this is  sub
optimal), what else driver must support for AP?

Sending to several stations ? (IBSS already has this), have several
virtual devices (this is optional feature), what else?

Why iwl3945 still doesn't support AP mode?

If I patch it to support it (just add ap to list of allowed modes) will
it work? (I soon anyway try out....)

Best regards,
	Maxim Levitsky

