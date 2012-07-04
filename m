Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55913 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab2GDV44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 17:56:56 -0400
Received: by wgbds11 with SMTP id ds11so5169377wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2012 14:56:55 -0700 (PDT)
Message-ID: <4FF4BC24.4070904@gmail.com> (sfid-20120704_235701_066319_8F05BABF)
Date: Wed, 04 Jul 2012 23:56:52 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: wireless-regdb@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: wireless-regdb: Update regulatory rules for ES (Spain) on 5GHz and
 2.4GHz
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

As I said before:
http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000058.html
http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000059.html

All CEPT countries, except those listed above, should be clones
of the current DE configuration. These are the CEPT _basic rules_ :

(2400 - 2483.5 @ 40), (N/A, 100 mW)
(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
(5470 - 5725 @ 40), (N/A, 500 mW), DFS

*Furthermore their own local rules*


When "spectral power limits" and "transmitter power control"(TPC) will be
implemented [1], some values _should be revised_ .


I did it only for ES - Spain .


[1] http://linuxwireless.org/en/developers/todo-list#Regulatory_database_improvements
