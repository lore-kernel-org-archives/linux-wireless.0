Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45506 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478Ab2DJXCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 19:02:55 -0400
Received: by obbtb18 with SMTP id tb18so402680obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2012 16:02:55 -0700 (PDT)
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: brudley@broadcom.com, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 00/01] staging: replace open-coded ARRAY_SIZEs
Date: Tue, 10 Apr 2012 17:02:33 -0600
Message-Id: <1334098954-7556-1-git-send-email-jim.cromie@gmail.com> (sfid-20120411_010259_167558_FE64AC5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Follow-on patch replaces  open-coded ARRAY_SIZEs with the macro.

Done by spatch with http://coccinelle.lip6.fr/rules/array.cocci
