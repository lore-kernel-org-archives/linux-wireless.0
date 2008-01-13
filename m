Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:36054 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbYAMTPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 14:15:04 -0500
Received: by ug-out-1314.google.com with SMTP id z38so746687ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 11:15:01 -0800 (PST)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: remove unused variable
Date: Sun, 13 Jan 2008 20:14:53 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20080113194834.677af663@morte>
In-Reply-To: <20080113194834.677af663@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801132014.53522.IvDoorn@gmail.com> (sfid-20080113_191509_977686_BBF875C2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Remove an unused variable that caused a warning while building. Please note
> that the pipe obtained there isn't used anywhere else.

This patch is in wireless-2.6 already...

Ivo
