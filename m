Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:61691 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbXK0Tnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:43:52 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1087203nfb
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:43:48 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Please pull 'upstream' branch of rt2x00
Date: Tue, 27 Nov 2007 21:54:29 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272154.29350.IvDoorn@gmail.com> (sfid-20071127_211135_689338_1EFC0916)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Please merge the patches for 2.6.24
> 09 - Only update rssi average approximation on receiving beacon frames.
> 10 - Remove redundant code in rfkill setup
> 11 - Cleanup rfkill

Sorry that should be:
08 - Only update rssi average approximation on receiving beacon frames.
09 - Remove redundant code in rfkill setup
10 - Cleanup rfkill

Ivo
