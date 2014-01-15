Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64503 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaAOI1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 03:27:35 -0500
Received: by mail-wi0-f180.google.com with SMTP id d13so1836284wiw.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 00:27:34 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 15 Jan 2014 09:27:34 +0100
Message-ID: <CAND6uN=QH9v74G7Re=eKs7T=RHW6f8KKP2CG52dneGWqhoTcwQ@mail.gmail.com> (sfid-20140115_092740_804841_05C8EC4C)
Subject: dynamic_ps_timeout with more than one vif
From: =?ISO-8859-1?Q?Magnus_Cederl=F6f?= <mcider@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am confused regarding the dynamic_ps_timeout parameter. This one is
set per hw in the function ieee80211_recalc_ps. But if there is more
than one vif, this parameter will not be set.

The ps_allowed parameter is sent to the drivers for each vif using the
BSS_CHANGED_PS flag. But I cannot find anything for the ps_timeout.
Maybe I have overlooked something. Can someone give some piece of
advice on how this case should be handles?

Thanks,
Magnus Cederlöf
