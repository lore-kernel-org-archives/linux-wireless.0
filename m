Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:32181 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab0DOU2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 16:28:42 -0400
Received: by qw-out-2122.google.com with SMTP id 8so586734qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 13:28:41 -0700 (PDT)
Message-ID: <4BC776F4.80600@gmail.com>
Date: Thu, 15 Apr 2010 16:28:36 -0400
From: Eric Siegel <nticompass@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Compiling ar9170 on 2.6.30
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was trying to compile ar9170 from today's tarball, and I got a compile
error.
ar9170/main.c:2060: error: expected ‘;’ before ‘mchash’
