Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4954 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab1LPJ1i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 04:27:38 -0500
Message-ID: <4EEB0EFC.5000302@broadcom.com> (sfid-20111216_102800_182196_AFD2D6CF)
Date: Fri, 16 Dec 2011 10:27:24 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: unexpected taint message
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To whoever may know,

Upon loading our driver module I get the following message:

kernel: [  344.805106] Disabling lock debugging due to kernel taint

What exactly are the criteria for tainting? Our driver locking strategy
is something we want to refactor and having lock debugging during that
transition may be a life safer.

Gr. AvS

