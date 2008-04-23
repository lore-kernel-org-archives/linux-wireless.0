Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:54227 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbYDWMlI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 08:41:08 -0400
Date: Wed, 23 Apr 2008 14:41:06 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: iwl4965 regression since 2.6.24
Message-ID: <20080423124105.GA4783@ics.muni.cz> (sfid-20080423_144157_522628_71BEBF36)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

as of 2.6.25 kernel, the intel driver iwl4965 has serious troubles to
associate with AP. I must many times set essid till the association is =
done.

Moreover, it seems that it is unable to associate with different AP (us=
ing the
same SSID). I must remove the module completly to be able to associate =
to the
different AP. I think it is big regression.

--=20
Luk=E1=B9 Hejtm=E1nek
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
