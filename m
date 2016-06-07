Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35220 "EHLO
	mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161495AbcFGPNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 11:13:49 -0400
MIME-Version: 1.0
From: David Binderman <linuxdev.baldrick@gmail.com>
Date: Tue, 7 Jun 2016 16:13:48 +0100
Message-ID: <CAMzoamY2uhXDsLsE2o8mCF923XXWoGp3oF_AMmVnDY=EuachZA@mail.gmail.com> (sfid-20160607_171608_517042_57803FB4)
Subject: linux-4.7-rc2/drivers/net/wireless/ath/ath6kl/wmi.c:2547]: (style)
 Redundant condition
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	dcb314@hotmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

linux-4.7-rc2/drivers/net/wireless/ath/ath6kl/wmi.c:2547]: (style)
Redundant condition: If 'EXPR <= 7', the comparison 'EXPR < 8' is
always true.

Source code is

    if (!((params->user_pri < 8) &&
          (params->user_pri <= 0x7) &&

This might be a possible cut'n'paste error. Also in the same file

[drivers/net/wireless/ath/ath6kl/wmi.c:1220]: (style) Variable 'rate'
is assigned a value that is never used.
[drivers/net/wireless/ath/ath6kl/wmi.c:1484]: (style) Variable
'new_threshold' is assigned a value that is never used.
[drivers/net/wireless/ath/ath6kl/wmi.c:3521]: (style) Variable 'ret'
is assigned a value that is never used.

Regards

David Binderman
